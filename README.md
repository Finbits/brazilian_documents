# Brazilian Documents

![CI](https://github.com/Finbits/brazilian_documents/workflows/CI/badge.svg?branch=master)

Validate, format and valid brazilian CPFs and CNPJs.

## Installation

The package can be installed by adding `brazilian_documents` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:brazilian_documents, "~> 0.2.1"}
  ]
end
```

The docs can be found at [https://hexdocs.pm/brazilian_documents](https://hexdocs.pm/brazilian_documents).

## Usage

```elixir
cpf = BrazilianDocuments.generate_cpf()
# "42111813516"
BrazilianDocuments.valid_cpf?(cpf)
# true
BrazilianDocuments.format_cpf(cpf)
# {:ok, "421.118.135-16"}
cnpj = BrazilianDocuments.generate_cnpj()
# "82767804491812"
BrazilianDocuments.valid_cnpj?(cnpj)
# true
BrazilianDocuments.format_cnpj(cnpj)
# {:ok, "82.767.804/4918-12"}
```

### Ecto Integration

```elixir
import BrazilianDocuments.Changeset

def changeset(target \\ %__MODULE__{}, attrs) do
  target
  |> cast(attrs, @fields)
  |> validate_required(@required_fields)
  |> validate_cpf(:cpf)
  |> validate_cnpj(:cnpj)
end
```

You can use the type modules in your schemas

```elixir
alias BrazilianDocuments.Types.{CNPJ, CPF}

schema "table" do
  field :cpf, CPF
  field :cnpj, CNPJ
end
```

## License

[Apache License, Version 2.0](LICENSE) © [Finbits](https://github.com/Finbits)
