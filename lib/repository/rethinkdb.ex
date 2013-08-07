defmodule Scarecrow.Repository.Rethinkdb do
  use Athink

  defrecord Result,
    generated_keys: [],
    deleted: 0, inserted: 0, replaced: 0, skipped: 0, unchanged: 0,
    new_val: nil, old_val: nil,
    first_error: nil, errors: 0

  defrecordp :repo, __MODULE__, module: nil

  def new(module) do
    repo(module: module)
  end

  def table(repo(module: module)) do
    r.table(module.collection_name)
  end

  def save(data, repo() = self) do
    id = data_access(data, :id)
    unless id do
      insert(data, self)
    else
      update(id, data, self)
    end
  end

  def insert(data, repo() = self) do
    reql = self.table.insert(data, return_vals: true)
    update_or_insert(reql, self)
  end

  def update(id, data, repo() = self) do
    reql = self.table.get(id).update(data, return_vals: true)
    update_or_insert(reql, self)
  end

  def remove_all_keys(repo() = self) do
    write_reql(self.table.delete, self)
  end

  def collection_drop(repo(module: module) = self) do
    format_response(r(r.table_drop(module.collection_name)), self)
  end

  def collection_info(repo() = self) do
    format_response(r(self.table.info), self)
  end

  # Private session
  defp update_or_insert(reql, repo() = self) do
    case write_reql(reql, self) do
      {:ok, Result[replaced: replaced, inserted: inserted, errors: 0.0, new_val: new_val]} when
        replaced >= 1 or inserted >= 1 ->
        format_response(new_val, self)
      result ->
        format_response(result, self)
    end
  end

  defp write_reql(reql, repo() = self) do
    case format_response(run_reql(reql, self), Result, self) do
      {:ok, Result[errors: errors] = result} when errors > 0 ->
        {:error, result}
      result ->
        result
    end
  end

  defp run_reql(reql, try_c // 0, repo(module: module) = self) do
    case r(reql) do
      # Auto table create
      {:error, _, :RUNTIME_ERROR, {:backtrace, [{:frame, :POS, 0, :undefined}]}} ->
        case r(r.table_create(module.collection_name)) do
          {:ok, _result} when try_c == 0 ->
            run_reql(reql, 1, self)
          error -> error
        end
      result -> result
    end
  end

  defp format_response(data, repo() = self) do
    format_response(data, HashDict, self)
  end

  defp format_response({:ok, data}, record_type, repo() = self) do
    format_response(data, record_type, self)
  end

  defp format_response(data, record_type, repo()) when is_record(data, HashDict) do
    {:ok, apply(record_type, :new, [convert_keys_to_atom(data.to_list)])}
  end

  defp format_response(data, _record_type, repo()) do
    data
  end

  defp convert_keys_to_atom(dict) do
    Enum.map(dict, fn
      {key, value} when is_atom(key) -> {key, value}
      {key, value} -> {:'#{key}', value}
    end)
  end

  defp data_access(data, key) when is_record(data, HashDict) do
    data[key]
  end
end
