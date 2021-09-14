defmodule BrazilianDocuments.Types.CNPJTest do
  use ExUnit.Case, async: true

  alias BrazilianDocuments.Types.CNPJ

  describe "cast/1" do
    test "cast a valid CNPJ number" do
      cnpj_number = "33426611000155"

      assert CNPJ.cast(cnpj_number) == {:ok, %CNPJ{number: cnpj_number}}
    end

    test "cast a formatted CNPJ number" do
      cnpj_number = "90.536.710/0001-23"

      assert CNPJ.cast(cnpj_number) == {:ok, %CNPJ{number: "90536710000123"}}
    end

    test "cast a CNPJ struct" do
      cnpj = %CNPJ{number: "90536710000123"}

      assert CNPJ.cast(cnpj) == {:ok, cnpj}
    end

    test "error for invalid CNPJ number" do
      assert CNPJ.cast("81083073") == :error
    end

    test "error for invalid argument" do
      assert CNPJ.cast(90_536_710_000_123) == :error
    end
  end

  describe "load/1" do
    test "load CNPJ as struct" do
      cnpj_number = "33426611000155"

      assert CNPJ.load(cnpj_number) == {:ok, %CNPJ{number: cnpj_number}}
    end

    test "load a CNPJ struct" do
      cnpj = %CNPJ{number: "90536710000123"}

      assert CNPJ.load(cnpj) == {:ok, cnpj}
    end

    test "return error when cant cast the loaded value" do
      assert CNPJ.load("invalid") == :error
    end
  end

  describe "dump/1" do
    test "dumb a CNPJ struct" do
      cnpj = %CNPJ{number: "90536710000123"}

      assert CNPJ.dump(cnpj) == {:ok, cnpj.number}
    end

    test "dump CNPJ as string" do
      cnpj_number = "33426611000155"

      assert CNPJ.dump(cnpj_number) == {:ok, cnpj_number}
    end

    test "return error when cant cast the loaded value" do
      assert CNPJ.dump(98_083_335_088) == :error
    end
  end

  describe "Protocol [Inspect]" do
    test "return formatted CNPJ number" do
      cnpj = %CNPJ{number: "90536710000123"}

      assert inspect(cnpj) == "#CNPJ<90.536.710/0001-23>"
    end

    test "invalid CNPJ" do
      cnpj = %CNPJ{number: "invalid"}

      assert inspect(cnpj) == "#Invalid CNPJ<invalid>"
    end
  end

  describe "Protocol [String.Chars]" do
    test "return number value" do
      cnpj = %CNPJ{number: "90536710000123"}

      assert to_string(cnpj) == cnpj.number
    end
  end
end
