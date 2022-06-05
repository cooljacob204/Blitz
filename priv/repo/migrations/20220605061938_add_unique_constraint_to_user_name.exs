defmodule Blitz.Repo.Migrations.AddUniqueConstraintToUserName do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:name, :room_id])
  end
end
