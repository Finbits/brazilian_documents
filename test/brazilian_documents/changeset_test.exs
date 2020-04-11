defmodule BrazilianDocuments.ChangesetTest do
  use ExUnit.Case, async: true
  import Ecto.Changeset
  import BrazilianDocuments.Changeset

  defmodule User do
    use Ecto.Schema

    @primary_key false
    embedded_schema do
      field(:cpf)
      field(:cnpj)
    end
  end

  defp build_changeset(schema \\ %User{}, params) do
    cast(schema, params, [:cpf, :cnpj])
  end

  describe "validate_cpf/3" do
    test "valid cpf" do
      changeset =
        %{cpf: "42111813516"}
        |> build_changeset()
        |> validate_cpf(:cpf)

      assert changeset.valid? == true
      assert changeset.errors == []
    end

    test "invalid cpf" do
      changeset =
        %{cpf: "invalid"}
        |> build_changeset()
        |> validate_cpf(:cpf)

      assert changeset.valid? == false
      assert changeset.errors == [cpf: {"has invalid cpf", []}]
    end

    test "cpf not present" do
      changeset =
        %{}
        |> build_changeset()
        |> validate_cpf(:cpf)

      assert changeset.valid? == true
      assert changeset.errors == []
    end

    test "optional message" do
      changeset =
        %{cpf: "invalid"}
        |> build_changeset()
        |> validate_cpf(:cpf, message: "my custom message")

      assert changeset.valid? == false
      assert changeset.errors == [cpf: {"my custom message", []}]
    end
  end

  describe "validate_cnpj/3" do
    test "valid cnpj" do
      changeset =
        %{cnpj: "82767804491812"}
        |> build_changeset()
        |> validate_cnpj(:cnpj)

      assert changeset.valid? == true
      assert changeset.errors == []
    end

    test "invalid cnpj" do
      changeset =
        %{cnpj: "invalid"}
        |> build_changeset()
        |> validate_cnpj(:cnpj)

      assert changeset.valid? == false
      assert changeset.errors == [cnpj: {"has invalid cnpj", []}]
    end

    test "cnpj not present" do
      changeset =
        %{}
        |> build_changeset()
        |> validate_cnpj(:cnpj)

      assert changeset.valid? == true
      assert changeset.errors == []
    end

    test "optional message" do
      changeset =
        %{cnpj: "invalid"}
        |> build_changeset()
        |> validate_cnpj(:cnpj, message: "my custom message")

      assert changeset.valid? == false
      assert changeset.errors == [cnpj: {"my custom message", []}]
    end
  end
end
