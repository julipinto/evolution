defmodule Evolution.Core.Guardian do
  @moduledoc """
  Guardian configuration for Evolution.
  """

  use Guardian, otp_app: :evolution

  alias Evolution.Repositories.User.Store

  def subject_for_token(%{id: id}, _claims) do
    {:ok, "#{id}"}
  end

  def subject_for_token(_, _claims), do: {:error, "Invalid subject"}

  def resource_from_claims(%{"sub" => id}) do
    case Store.get_by_id(id) do
      nil -> {:error, "Invalid resource"}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_), do: {:error, "Invalid resource"}
end
