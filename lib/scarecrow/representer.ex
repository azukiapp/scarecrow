defmodule Scarecrow.Representer do
  defmacro __using__(_opts) do
    quote do
      import :macros, unquote(__MODULE__)
      Module.register_attribute __MODULE__, :properties, accumulate: true
      Module.register_attribute __MODULE__, :links, accumulate: true

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote location: :keep do
      def build(data) do
        unquote(__MODULE__).build_data(__MODULE__, @properties, @links, data)
      end
    end
  end

  defmacro property(p) do
    quote do
      @properties unquote(p)
    end
  end

  defmacro link(type, contents) do
    var  = {:represented, [], nil}
    func = :"link_#{type}"

    quote do
      @links unquote(type)
      def unquote(func), [unquote(Macro.escape var)], [],
        unquote(Macro.escape contents, unquote: true)
    end
  end

  def build_data(module, properties, links, data) when is_record(data) and not is_record(data, HashDict) do
    build_data(module, properties, links, data.to_keywords)
  end

  def build_data(module, properties, links, data) do
    # Fix key acess
    data = Enum.map(data, fn
      {key, value} -> { :"#{key}", value }
    end)

    dict = Enum.map(properties, fn(pro) -> {pro, data[pro]} end)
    dict = Dict.put(dict, :_links, Enum.map(links, fn(link) ->
      {link, [ href: apply(module, :"link_#{link}", [data])]}
    end))
    :jsx.encode(dict, pre_encode: fn
      nil -> :null
      value -> value
    end)
  end
end

