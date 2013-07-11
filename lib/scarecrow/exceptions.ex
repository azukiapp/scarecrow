defmodule Scarecrow.Expections do
  @errors [
    {404, :jsx.encode([ error: "Not found" ])},
    {500, :jsx.encode([ error: "Internal error"])}
  ]

  def service(conn) do
    { status, _kind, _value, _stacktrace } = conn.assigns[:exception]
    case [Mix.env, status] do
      [:prod, _] ->
        json(conn).send(status, @errors[status])
      [:dev , 404] ->
        json(conn).send(status, @errors[status])
      _ ->
        Dynamo.Filters.Exceptions.Debug.service(conn)
    end
  end

  defp json(conn) do
    conn
      .resp_content_type("application/json")
      .resp_charset "utf-8"
  end
end
