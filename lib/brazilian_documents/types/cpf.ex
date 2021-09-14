if Code.ensure_loaded?(Ecto.Type) do
  defmodule BrazilianDocuments.Types.CPF do
    @moduledoc """
    An `Ecto.Type` for CPF.
    """
    use Ecto.Type

    defstruct [:number]

    def type, do: :string

    def cast(value) when is_binary(value) do
      raw_value = String.replace(value, ~r/\D/, "")

      if BrazilianDocuments.valid_cpf?(raw_value) do
        {:ok, %__MODULE__{number: raw_value}}
      else
        :error
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
        {:ok, cpf} -> dump(cpf)
        :error -> :error
      end
    end

    def dump(_invalid), do: :error
  end

  defimpl Inspect, for: BrazilianDocuments.Types.CPF do
    def inspect(%{number: cpf_number}, _opts) do
      case BrazilianDocuments.format_cpf(cpf_number) do
        {:ok, formatted_cpf} -> "#CPF<#{formatted_cpf}>"
        :error -> "#Invalid CPF<#{cpf_number}>"
      end
    end
  end

  defimpl String.Chars, for: BrazilianDocuments.Types.CPF do
    def to_string(%{number: cpf_number}) when is_binary(cpf_number) do
      cpf_number
    end
  end
end
