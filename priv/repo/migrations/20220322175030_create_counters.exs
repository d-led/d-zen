defmodule Dzen.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :key, :string, null: false
      add :value, :integer, default: 0
    end

    create unique_index(:counters, [:key])
  end
end
