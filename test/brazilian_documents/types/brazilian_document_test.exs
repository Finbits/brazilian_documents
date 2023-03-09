defmodule BrazilianDocuments.Types.BrazilianDocumentTest do
  use ExUnit.Case, async: true

  alias BrazilianDocuments.Types.BrazilianDocument
  alias BrazilianDocuments.Types.CNPJ
  alias BrazilianDocuments.Types.CPF

  describe "cast/1" do
    test "cast a valid CNPJ as a BrazilianDocument" do
      cnpj_number = "33426611000155"

      assert BrazilianDocument.cast(cnpj_number) ==
               {:ok, %BrazilianDocument{number: cnpj_number, kind: :cnpj}}
    end

    test "cast a formatted CNPJ as a BrazilianDocument" do
      cnpj_number = "90.536.710/0001-23"

      assert BrazilianDocument.cast(cnpj_number) ==
               {:ok, %BrazilianDocument{number: "90536710000123", kind: :cnpj}}
    end

    test "cast a valid CPF as a BrazilianDocument" do
      cpf_number = "09581083073"

      assert BrazilianDocument.cast(cpf_number) ==
               {:ok, %BrazilianDocument{number: cpf_number, kind: :cpf}}
    end

    test "cast a formatted CPF as a BrazilianDocument" do
      cpf_number = "980.833.350-88"

      assert BrazilianDocument.cast(cpf_number) ==
               {:ok, %BrazilianDocument{number: "98083335088", kind: :cpf}}
    end

    test "cast a BrazilianDocument type structs" do
      brazilian_document_cnpj = %BrazilianDocument{number: "90536710000123", kind: :cnpj}
      cnpj = %CNPJ{number: "90536710000123"}

      brazilian_document_cpf = %BrazilianDocument{number: "47729076020", kind: :cpf}
      cpf = %CPF{number: "47729076020"}

      assert BrazilianDocument.cast(cnpj) == {:ok, brazilian_document_cnpj}
      assert BrazilianDocument.cast(brazilian_document_cnpj) == {:ok, brazilian_document_cnpj}

      assert BrazilianDocument.cast(cpf) == {:ok, brazilian_document_cpf}
      assert BrazilianDocument.cast(brazilian_document_cpf) == {:ok, brazilian_document_cpf}
    end

    test "error for invalid brazilian document number" do
      assert BrazilianDocument.cast("81083073") == :error
    end

    test "error for invalid argument" do
      assert BrazilianDocument.cast(98_083_335_088) == :error
    end
  end

  describe "load/1" do
    test "load a CNPJ as a BrazilianDocument" do
      cnpj_number = "33426611000155"

      assert BrazilianDocument.load(cnpj_number) ==
               {:ok, %BrazilianDocument{number: cnpj_number, kind: :cnpj}}
    end

    test "load a CPF as a BrazilianDocument" do
      cpf_number = "09581083073"

      assert BrazilianDocument.load(cpf_number) ==
               {:ok, %BrazilianDocument{number: cpf_number, kind: :cpf}}
    end

    test "load a BrazilianDocument struct" do
      cnpj = %BrazilianDocument{number: "90536710000123", kind: :cnpj}

      assert BrazilianDocument.load(cnpj) == {:ok, cnpj}
    end

    test "return error when cant cast the loaded value" do
      assert BrazilianDocument.load("invalid") == :error
    end
  end

  describe "dump/1" do
    test "dumb a CNPJ BrazilianDocument struct" do
      brazilian_document_cnpj = %BrazilianDocument{number: "90536710000123", kind: :cnpj}
      brazilian_document_cpf = %BrazilianDocument{number: "98083335088", kind: :cpf}
      cnpj = %CNPJ{number: "90536710000123"}
      cpf = %CPF{number: "47729076020"}

      assert BrazilianDocument.dump(brazilian_document_cnpj) ==
               {:ok, brazilian_document_cnpj.number}

      assert BrazilianDocument.dump(brazilian_document_cpf) ==
               {:ok, brazilian_document_cpf.number}

      assert BrazilianDocument.dump(cnpj) == {:ok, cnpj.number}
      assert BrazilianDocument.dump(cpf) == {:ok, cpf.number}
    end

    test "dump BrazilianDocument as string" do
      cnpj_number = "33426611000155"

      assert BrazilianDocument.dump(cnpj_number) == {:ok, cnpj_number}
    end

    test "return error when cant cast the loaded value" do
      assert BrazilianDocument.dump(98_083_335_088) == :error
    end
  end

  describe "Protocol [Inspect]" do
    test "return formatted BrazilianDocument number" do
      cnpj = %BrazilianDocument{number: "90536710000123", kind: :cnpj}
      cpf = %BrazilianDocument{number: "98083335088", kind: :cpf}

      assert inspect(cpf) == "#CPF<980.833.350-88>"
      assert inspect(cnpj) == "#CNPJ<90.536.710/0001-23>"
    end

    test "invalid BrazilianDocument" do
      cnpj = %BrazilianDocument{number: "invalid", kind: :cnpj}

      assert inspect(cnpj) == "#Invalid CNPJ<invalid>"
    end
  end

  describe "Protocol [String.Chars]" do
    test "return number value" do
      cnpj = %BrazilianDocument{number: "90536710000123", kind: :cnpj}
      cpf = %BrazilianDocument{number: "98083335088", kind: :cpf}

      assert to_string(cnpj) == cnpj.number
      assert to_string(cpf) == cpf.number
    end
  end
end
