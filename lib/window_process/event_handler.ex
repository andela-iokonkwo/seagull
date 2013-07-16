defmodule WindowProcess.EventHandler do

  def respond(object, :react, {event, pid}) do
    Event.react Keyword.put(object, :pid, pid), event
  end
  def respond(object, :react, event), do: respond object, :react, {event, Keyword.get(object, :pid)}
  def respond(object, funct, options), do: WindowProcesss.Object.respond object, funct, options

end
