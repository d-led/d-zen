defmodule Dzen.Counter do
  use Ecto.Schema

  schema "counters" do
    field :key, :string
    field :value, :integer, default: 0
  end

  def changeset(counter, params \\ %{}) do
    counter
    |> Ecto.Changeset.cast(params, [:key, :value])
    |> Ecto.Changeset.validate_required([:key])
  end
end
