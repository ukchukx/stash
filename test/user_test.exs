defmodule Stash.UserTest do
  alias Stash.{Accounts, DataCase}
  alias Stash.Projections.User

  use DataCase

  @moduletag models: :user
  @moduletag :user

  describe "a user" do
    test "can be created" do
      assert {:ok, %User{id: user_id}} = fixture(:user)
      assert {:ok, _} = Accounts.user_by_id(user_id)
    end

    test "can be updated" do
      assert {:ok, %User{} = user} = fixture(:user)

      params = build_user_params() |> Map.take([:email, :password])

      assert {:ok, %User{} = updated_user} = Accounts.update_user(user, params)

      # Unchanged
      assert user.id == updated_user.id
      assert user.active == updated_user.active
      # Changed
      assert updated_user.email == params.email
      refute updated_user.password == user.password
    end

    test "can be disabled" do
      assert {:ok, %User{id: user_id} = user} = fixture(:user)
      assert {:ok, %User{active: false, id: ^user_id}} = Accounts.disable_user(user)
    end

    test "cannot be disabled if already disabled" do
      assert {:ok, %User{} = user} = fixture(:user)
      assert {:ok, %User{} = disabled_user} = Accounts.disable_user(user)
      assert {:error, :already_disabled} = Accounts.disable_user(disabled_user)
    end

    test "can be enabled" do
      assert {:ok, %User{id: user_id} = user} = fixture(:user)
      assert {:ok, %User{} = disabled_user} = Accounts.disable_user(user)
      assert {:ok, %User{active: true, id: ^user_id}} = Accounts.enable_user(disabled_user)
    end

    test "cannot be enabled if already enabled" do
      assert {:ok, %User{} = user} = fixture(:user)
      assert {:error, :already_enabled} = Accounts.enable_user(user)
    end
  end

  describe "a list" do
    test "can be created" do
      assert {:ok, %User{lists: []} = user} = fixture(:user)
      params = build_list_params()
      assert {:ok, %User{lists: [_list]}} = Accounts.create_list(params, %{user: user})
    end

    test "can be updated" do
      {:ok, %User{lists: []} = user} = fixture(:user)
      params = build_list_params()

      {:ok, %User{lists: [list = %{"type" => type}]}} =
        Accounts.create_list(params, %{user: user})

      params = build_list_params()
      {:ok, %User{lists: [list]}} = Accounts.update_list(user, list["id"], params)
      assert list["name"] == params.name
      assert list["type"] == type
    end

    test "can be deleted" do
      assert {:ok, %User{lists: []} = user} = fixture(:user)
      params = build_list_params()
      assert {:ok, %User{lists: [list]}} = Accounts.create_list(params, %{user: user})
      assert :ok = Accounts.delete_list(user, list["id"])
      assert {:ok, %User{lists: []}} = Accounts.user_by_id(user.id)
    end
  end
end
