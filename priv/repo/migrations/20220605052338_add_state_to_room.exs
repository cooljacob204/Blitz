defmodule Blitz.Repo.Migrations.AddStateToRoom do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE room_state AS ENUM ('lobby','game');",
      "DROP TYPE room_state;"
     )

    alter table :rooms do
      add :state, :room_state, default: "lobby", null: false
    end
  end
end
