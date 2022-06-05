defmodule Blitz.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :room_id, references(:rooms, on_delete: :delete_all)

      timestamps()
    end

    create index(:users, [:room_id])
  end
end
