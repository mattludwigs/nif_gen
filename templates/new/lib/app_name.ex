defmodule <%= app_module %> do
  @moduledoc """
  Documentation for <%= app_module %>.
  """

  @on_load :load_nif
  @doc false
  def load_nif do
    nif_file = Path.join(:code.priv_dir(:<%= app_name %>), "<%= app_name %>_nif") |> to_charlist()

    case :erlang.load_nif(nif_file, 0) do
      :ok -> :ok
      {:error, {:reload, _}} -> :ok
      {:error, reason} -> {:error, :load_failed, reason}
    end
  end

  def init, do: :erlang.nif_error("<%= app_name %> nif not loaded")
  def add(_resource, _data), do: :erlang.nif_error("<%= app_name %> nif not loaded")
end
