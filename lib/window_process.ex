defmodule WindowProcess do
  
  def start(frame, pid//self()) do
    spawn WindowProcess, :start_proc, [frame, pid]
  end

  def start_proc(frame, pid) do
    :wx.new
    window=Compiler.compile(frame, pid)
    [{_id, data}|_tail]=window
    :wxFrame.show Keyword.get(data, :wxobject)
    rec(window, pid)
    :wx.destroy
  end

  defp rec(window, pid) do
    receive do
      :destroy->
        nil
      {pid, id, function, params}->
        send window, pid, id, function, params
        rec window, pid
      a-> 
        IO.inspect a
        rec window, pid
    end
  end

  defp send(window, pid, id, func, params) do
    {type, object}=Keyword.get window, id
    pid<-{self(), id, func, get(type, object, func, params)}
  end

  defp get(:button, object, func, params), do: WindowProcess.Button.get object, func, params
  defp get(:frame, object, func, params), do: WindowProcess.Frame.get object, func, params
  defp get(_type, _object, _func, _params), do: :uknown_type

  def selfdestruct(), do: self() <- :destroy

end
