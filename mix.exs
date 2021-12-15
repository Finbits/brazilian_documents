defmodule BrazilianDocuments.MixProject do
  use Mix.Project

  def project do
    [
      app: :brazilian_documents,
      version: "0.3.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Validate, format and valid brazilian CPFs and CNPJs",
      package: package(),
      name: "Brazilian Documents",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Finbits/brazilian_documents"}
    ]
  end

  defp docs do
    [
      main: "BrazilianDocuments",
      source_url: "https://github.com/Finbits/brazilian_documents"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.25.2", only: :dev, runtime: false},
      {:ecto, "~> 3.0", optional: true}
    ]
  end
end
