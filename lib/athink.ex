defmodule Athink do
  alias Lexthink.AST, as: L

  defrecordp :query, __MODULE__, terms: []

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__), only: [r: 0]

      def r(query) do
        query.run(:azuki)
      end
    end
  end

  # MANIPULATING DATABASES
  @spec db_create(binary) :: :term.t
  def db_create(name) do
    new_term(db_create: [name])
  end

  @spec db_drop(binary) :: :term.t
  def db_drop(name) do
    new_term(db_drop: [name])
  end

  @spec db_list() :: :term.t
  def db_list() do
    new_term(db_list: [])
  end

  # MANIPULATING TABLES
  @spec table_list() :: :query.t
  def table_list do
    new_term(table_list: [])
  end

  @spec table_list(:query.t()) :: :query.t
  def table_list(query() = old) do
    new_term(old, table_list: [])
  end

  # SELECTING DATA
  @spec db(binary) :: :query.t
  def db(name) do
    new_term(db: [name])
  end

  @spec table(binary) :: :query.t
  def table(name) do
    new_term(table: [name])
  end

  @spec table(binary, :query.t()) :: :query.t
  def table(name, query() = old) do
    new_term(old, tabel: [name])
  end

  @spec insert(Dict.t | [Dict.t], Keyword.t) :: :term.t
  def insert(data, options // [], query() = old) do
    new_term(old, insert: [data, options])
  end

  @spec filter(Dict.t | [Dict.t] | fun, Keyword.t) :: :query.t
  def filter(data, options // [], query() = old) do
    new_term(old, filter: [data, options])
  end

  @spec update(Dict.t | fun, Keyword.t) :: :query.t
  def update(data, options // [], query() = old) do
    new_term(old, update: [data, options])
  end

  @spec delete(Keyword.t) :: :query.t
  def delete(options // [], query() = old) do
    new_term(old, delete: [options])
  end

  # CONTROL STRUCTURES
  @spec type_of(:query.t) :: :query.t
  def type_of(query() = old) do
    new_term(old, term: [[type: :'TYPEOF']])
  end

  @spec info(:query.t) :: :query.t
  def info(query() = old) do
    new_term(old, term: [[type: :'INFO']])
  end

  def expr(expr_arg, query() = old) do
    new_term(old, expr: [expr_arg])
  end

  def expr(expr_arg) do
    new_term(expr: [expr_arg])
  end

  # ACCESSING RQL
  def r do
    __MODULE__
  end

  def run(pool, query() = old) do
    Lexthink.run(old.build, pool)
  end

  #%% Math and logic
  @operators [
    :add, :sub, :mul, :div, :mod,
    :or_, :and_, :not_,
    :eq, :ne, :gt, :ge, :lt, :le
  ]

  Module.eval_quoted __MODULE__, Enum.map(@operators, fn(logic) ->
    quote do
      def unquote(logic)(term, value) do
        apply(L, unquote(logic), [term, value])
      end
    end
  end)

  # Utils
  def build(query(terms: terms)) do
    Enum.reduce(terms, nil, fn([func, args], terms) ->
      case func do
        :term ->
          [mod, func] = [:term, :new]
          if terms != nil, do: args = [Keyword.put(List.flatten(args), :args, terms)]
        _ ->
          mod = L
          if terms != nil, do: args = [terms] ++ args
      end
      apply(mod, func, args)
    end)
  end

  defp new_term([{func, args}]) do
    query(terms: [[func, args]])
  end

  defp new_term(query(terms: terms) = old, [{func, args}]) do
    query(old, terms: terms ++ [[func, args]])
  end
end
