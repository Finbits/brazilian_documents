defmodule BrazilianDocuments do
  @moduledoc """
  Documentation for BrazilianDocuments.
  """

  @doc """
  Check if value is a valid CPF.

  ## Examples

      iex> BrazilianDocuments.valid_cpf?("366.418.768-70")
      true

      iex> BrazilianDocuments.valid_cpf?("36641876870")
      true

      iex> BrazilianDocuments.valid_cpf?("366.418")
      false

      iex> BrazilianDocuments.valid_cpf?("213.198.013-20")
      false

      iex> BrazilianDocuments.valid_cpf?("2131201872781")
      false

      iex> BrazilianDocuments.valid_cpf?("11111111111")
      false

  """
  @spec valid_cpf?(value :: String.t()) :: boolean()
  def valid_cpf?(value) when is_binary(value) do
    if Regex.match?(~r/^(\d{11}|\d{3}\.\d{3}\.\d{3}\-\d{2})$/, value) do
      numbers = to_numbers_list(value)

      not all_numbers_equal?(numbers) and
        valid_checker_digits?(numbers, 9, [11, 10, 9, 8, 7, 6, 5, 4, 3, 2])
    else
      false
    end
  end

  @doc """
  Check if value is a valid CNPJ.

  ## Examples

      iex> BrazilianDocuments.valid_cnpj?("69.103.604/0001-60")
      true

      iex> BrazilianDocuments.valid_cnpj?("41142260000189")
      true

      iex> BrazilianDocuments.valid_cnpj?("411407182")
      false

      iex> BrazilianDocuments.valid_cnpj?("11.111.111/1111-11")
      false

  """
  @spec valid_cpf?(value :: String.t()) :: boolean()
  def valid_cnpj?(value) when is_binary(value) do
    if Regex.match?(~r/^(\d{14}|\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2})$/, value) do
      numbers = to_numbers_list(value)

      not all_numbers_equal?(numbers) and
        valid_checker_digits?(numbers, 12, [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2])
    else
      false
    end
  end

  @doc """
  Format a CPF value.

  ## Examples

      iex> BrazilianDocuments.format_cpf("21987198433")
      {:ok, "219.871.984-33"}

      iex> BrazilianDocuments.format_cpf("219.871.984-33")
      {:ok, "219.871.984-33"}

      iex> BrazilianDocuments.format_cpf("62653322064594")
      :error

      iex> BrazilianDocuments.format_cpf("123")
      :error

      iex> BrazilianDocuments.format_cpf("invalid")
      :error

  """
  @spec format_cpf(value :: String.t()) :: {:ok, String.t()} | :error
  def format_cpf(value) when is_binary(value) do
    if valid_cpf?(value) do
      {:ok,
       String.replace(value, ~r/^(\d{3})(\d{3})(\d{3})(\d{2})$/, "\\g{1}.\\g{2}.\\g{3}-\\g{4}")}
    else
      :error
    end
  end

  @doc """
  Format a CNPJ value.

  ## Examples

      iex> BrazilianDocuments.format_cnpj("28603414938513")
      {:ok, "28.603.414/9385-13"}

      iex> BrazilianDocuments.format_cnpj("57.120.949/4422-42")
      {:ok, "57.120.949/4422-42"}

      iex> BrazilianDocuments.format_cnpj("91084416506")
      :error

      iex> BrazilianDocuments.format_cnpj("123")
      :error

      iex> BrazilianDocuments.format_cnpj("invalid")
      :error

  """
  @spec format_cnpj(value :: String.t()) :: {:ok, String.t()} | :error
  def format_cnpj(value) when is_binary(value) do
    if valid_cnpj?(value) do
      {:ok,
       String.replace(
         value,
         ~r/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/,
         "\\g{1}.\\g{2}.\\g{3}/\\g{4}-\\g{5}"
       )}
    else
      :error
    end
  end

  @doc """
  Generate a unformatted CPF.

  ## Examples

      iex> cnpj = BrazilianDocuments.generate_cpf()
      iex> BrazilianDocuments.valid_cpf?(cnpj)
      true

  """
  @spec generate_cpf :: String.t()
  def generate_cpf do
    numbers = random_numbers(9)

    {first_digit, second_digit} = checker_digits(numbers, 9, [11, 10, 9, 8, 7, 6, 5, 4, 3, 2])

    numbers |> Enum.concat([first_digit, second_digit]) |> Enum.join("")
  end

  @doc """
  Generate a unformatted CNPJ.

  ## Examples

      iex> cnpj = BrazilianDocuments.generate_cnpj()
      iex> BrazilianDocuments.valid_cnpj?(cnpj)
      true

  """
  @spec generate_cnpj :: String.t()
  def generate_cnpj do
    numbers = random_numbers(12)

    {first_digit, second_digit} =
      checker_digits(numbers, 12, [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2])

    numbers |> Enum.concat([first_digit, second_digit]) |> Enum.join("")
  end

  defp random_numbers(amount) do
    (&random_number_generator_fun/0)
    |> Stream.repeatedly()
    |> Enum.take(amount)
  end

  defp random_number_generator_fun, do: Enum.random(0..9)

  defp valid_checker_digits?(numbers, size, verifiers) do
    {first_digit, second_digit} = checker_digits(numbers, size, verifiers)

    Enum.at(numbers, size) == first_digit and Enum.at(numbers, size + 1) == second_digit
  end

  defp all_numbers_equal?(numbers) do
    Enum.all?(numbers, fn x -> x == Enum.at(numbers, 0) end)
  end

  defp to_numbers_list(value) do
    value
    |> String.replace(~r/\D/, "")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp checker_digits(numbers, size, verifiers) do
    {_, first_digit_verifiers} = List.pop_at(verifiers, 0)

    first_digit =
      numbers
      |> Enum.take(size)
      |> Enum.zip(first_digit_verifiers)
      |> Enum.map(fn {a, b} -> a * b end)
      |> Enum.sum()
      |> rem(11)
      |> eleven_minus()

    second_digit =
      numbers
      |> Enum.take(size)
      |> Enum.concat([first_digit])
      |> Enum.zip(verifiers)
      |> Enum.map(fn {a, b} -> a * b end)
      |> Enum.sum()
      |> rem(11)
      |> eleven_minus()

    {first_digit, second_digit}
  end

  defp eleven_minus(num) when num < 2, do: 0
  defp eleven_minus(num), do: 11 - num
end
