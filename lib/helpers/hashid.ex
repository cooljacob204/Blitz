defmodule Helpers.Hashid do
  def encode(id) do
    Hashids.encode(hashid_salt(), id)
  end

  def decode(id) do
    Hashids.decode!(hashid_salt(), id)
  end

  defp hashid_salt do
    Hashids.new([
      salt: "Super Secret Salt",  # using a custom salt helps producing unique cipher text
      min_len: 5,   # minimum length of the cipher text (1 by default)
    ])
  end
end
