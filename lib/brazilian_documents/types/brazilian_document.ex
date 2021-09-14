defmodule BrazilianDocuments.Types.BrazilianDocument do
  @moduledoc """
  A polymorphic `Ecto.Type` for brazilian documents.
  """
  use Ecto.Type

  import BrazilianDocuments, only: [valid_cnpj?: 1, valid_cpf?: 1]

  defstruct [:number, :kind]

  def type, do: :string

  def cast(value) when is_binary(value) do
    raw_value = String.replace(value, ~r/\D/, "")

    cond do
      valid_cnpj?(raw_value) -> {:ok, %__MODULE__{number: raw_value, kind: :cnpj}}
      valid_cpf?(raw_value) -> {:ok, %__MODULE__{number: raw_value, kind: :cpf}}
      true -> :error
    end
  end

  def cast(%__MODULE__{number: value}) when is_binary(value) do
    cast(value)
  end

  def cast(_invalid), do: :error

  def load(value), do: cast(value)

  def dump(%__MODULE__{number: number}), do: {:ok, number}

  def dump(value) when is_binary(value) do
    case cast(value) do
      {:ok, document} -> dump(document)
      :error -> :error
    end
  end

  def dump(_invalid), do: :error
end

defimpl Inspect, for: BrazilianDocuments.Types.BrazilianDocument do
  def inspect(%{number: cnpj_number, kind: :cnpj}, _opts) do
    case BrazilianDocuments.format_cnpj(cnpj_number) do
      {:ok, formatted_cnpj} -> "#CNPJ<#{formatted_cnpj}>"
      :error -> "#Invalid CNPJ<#{cnpj_number}>"
    end
  end

  def inspect(%{number: cpf_number, kind: :cpf}, _opts) do
    case BrazilianDocuments.format_cpf(cpf_number) do
      {:ok, formatted_cpf} -> "#CPF<#{formatted_cpf}>"
      :error -> "#Invalid CPF<#{cpf_number}>"
    end
  end
end

defimpl String.Chars, for: BrazilianDocuments.Types.BrazilianDocument do
  def to_string(%{number: cnpj_number}) when is_binary(cnpj_number) do
    cnpj_number
  end
end
