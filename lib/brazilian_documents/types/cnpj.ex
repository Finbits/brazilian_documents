if Code.ensure_loaded?(Ecto.Type) do
  defmodule BrazilianDocuments.Types.CNPJ do
    @moduledoc """
    An `Ecto.Type` for CNPJ.
    """
    use Ecto.Type

    defstruct [:number]

    def type, do: :string

    def cast(value) when is_binary(value) do
      raw_value = String.replace(value, ~r/\D/, "")

      if BrazilianDocuments.valid_cnpj?(raw_value) do
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
        {:ok, cnpj} -> dump(cnpj)
        :error -> :error
      end
    end

    def dump(_invalid), do: :error
  end

  defimpl Inspect, for: BrazilianDocuments.Types.CNPJ do
    def inspect(%{number: cnpj_number}, _opts) do
      case BrazilianDocuments.format_cnpj(cnpj_number) do
        {:ok, formatted_cnpj} -> "#CNPJ<#{formatted_cnpj}>"
        :error -> "#Invalid CNPJ<#{cnpj_number}>"
      end
    end
  end

  defimpl String.Chars, for: BrazilianDocuments.Types.CNPJ do
    def to_string(%{number: cnpj_number}) when is_binary(cnpj_number) do
      cnpj_number
    end
  end
end
