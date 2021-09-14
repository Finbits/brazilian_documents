defmodule BrazilianDocuments.Types.CPFTest do
  use ExUnit.Case, async: true

  alias BrazilianDocuments.Types.CPF

  describe "cast/1" do
    test "cast a valid CPF number" do
      cpf_number = "09581083073"

      assert CPF.cast(cpf_number) == {:ok, %CPF{number: cpf_number}}
    end

    test "cast a formatted CPF number" do
      cpf_number = "980.833.350-88"

      assert CPF.cast(cpf_number) == {:ok, %CPF{number: "98083335088"}}
    end

    test "cast a CPF struct" do
      cpf = %CPF{number: "98083335088"}

      assert CPF.cast(cpf) == {:ok, cpf}
    end

    test "error for invalid CPF number" do
      assert CPF.cast("81083073") == :error
    end

    test "error for invalid argument" do
      assert CPF.cast(98_083_335_088) == :error
    end
  end

  describe "load/1" do
    test "load CPF as struct" do
      cpf_number = "09581083073"

      assert CPF.load(cpf_number) == {:ok, %CPF{number: cpf_number}}
    end

    test "load a CPF struct" do
      cpf = %CPF{number: "98083335088"}

      assert CPF.load(cpf) == {:ok, cpf}
    end

    test "return error when cant cast the loaded value" do
      assert CPF.load("invalid") == :error
    end
  end

  describe "dump/1" do
    test "dumb a CPF struct" do
      cpf = %CPF{number: "98083335088"}

      assert CPF.dump(cpf) == {:ok, cpf.number}
    end

    test "dump CPF as string" do
      cpf_number = "09581083073"

      assert CPF.dump(cpf_number) == {:ok, cpf_number}
    end

    test "return error when cant cast the loaded value" do
      assert CPF.dump(98_083_335_088) == :error
    end
  end

  describe "Protocol [Inspect]" do
    test "return formatted CPF number" do
      cpf = %CPF{number: "98083335088"}

      assert inspect(cpf) == "#CPF<980.833.350-88>"
    end

    test "invalid CPF" do
      cpf = %CPF{number: "invalid"}

      assert inspect(cpf) == "#Invalid CPF<invalid>"
    end
  end

  describe "Protocol [String.Chars]" do
    test "return number value" do
      cpf = %CPF{number: "98083335088"}

      assert to_string(cpf) == cpf.number
    end
  end
end
