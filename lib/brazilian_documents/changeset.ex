if Code.ensure_loaded?(Ecto.Changeset) do
  defmodule BrazilianDocuments.Changeset do
    @moduledoc """
    Ecto changeset integration.
    """

    @doc """
    Validates a change is a valid CPF.

    ## Options

      * `:message` - the message on failure, defaults to "has invalid cpf"

    ## Examples

        validate_cpf(changeset, :cpf)

    """
    @spec validate_cpf(changeset :: Ecto.Changeset.t(), field :: atom(), opts :: Keyword.t()) ::
            Ecto.Changeset.t()
    def validate_cpf(%Ecto.Changeset{} = changeset, field, opts \\ [])
        when is_atom(field) and is_list(opts) do
      Ecto.Changeset.validate_change(changeset, field, fn ^field, value ->
        if BrazilianDocuments.valid_cpf?(value) do
          []
        else
          [{field, Keyword.get(opts, :message, "has invalid cpf")}]
        end
      end)
    end

    @doc """
    Validates a change is a valid CNPJ.

    ## Options

      * `:message` - the message on failure, defaults to "has invalid cnpj"

    ## Examples

        validate_cnpj(changeset, :cnpj)

    """
    @spec validate_cnpj(changeset :: Ecto.Changeset.t(), field :: atom(), opts :: Keyword.t()) ::
            Ecto.Changeset.t()
    def validate_cnpj(%Ecto.Changeset{} = changeset, field, opts \\ [])
        when is_atom(field) and is_list(opts) do
      Ecto.Changeset.validate_change(changeset, field, fn ^field, value ->
        if BrazilianDocuments.valid_cnpj?(value) do
          []
        else
          [{field, Keyword.get(opts, :message, "has invalid cnpj")}]
        end
      end)
    end
  end
end
