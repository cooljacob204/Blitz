defmodule Blitz.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :room_id, references(:rooms, on_delete: :delete_all), null: false

      timestamps()
    end

    create table(:scores) do
      add :round_id, references(:rounds, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :blitz_count, :integer, null: false
      add :hand_count, :integer, null: false

      timestamps()
    end
  end
end
