defmodule CliDateTimeTest do
  use ExUnit.Case, async: false
  doctest Snapex7

  # We don't have the way to test this function
  # (we've a plc s7-1200 and snap7 server doesn't support these functions)
  # These tests only help us to track the input variables.

  setup do
    System.put_env("LD_LIBRARY_PATH", "./src") #checar como cambiar esto para que use :code.priv_dir
    executable = :code.priv_dir(:snapex7) ++ '/s7_client.o'
    port =  Port.open({:spawn_executable, executable}, [{:args, []}, {:packet, 2}, :use_stdio, :binary, :exit_status])

    msg = {:connect_to, {"192.168.0.1", 0, 1}}
    send(port, {self(), {:command, :erlang.term_to_binary(msg)}})
    status =
      receive do
        {_, {:data, <<?r, response::binary>>}}  ->
          :erlang.binary_to_term(response)
        after
          10000  ->
            :error
      end

    %{port: port, status: status}
  end

  # test "handle_get_plc_date_time", state do
  #   msg = {:get_plc_date_time, nil} nil
  #   send(state.port, {self(), {:command, :erlang.term_to_binary(msg)}})

  #   c_response =
  #     receive do
  #       {_, {:data, <<?r, response::binary>>}} ->
  #         :erlang.binary_to_term(response)
  #       x ->
  #         IO.inspect(x)
  #         :error
  #     after
  #       1000 ->
  #         # Not sure how this can be recovered
  #         exit(:port_timed_out)
  #     end

  #   assert c_response == {:ok}
  # end

  # test "handle_set_plc_date_time", state do
  #   msg = {:set_plc_date_time, {1, 2, 3, 29, 12, 2018, 0, 355, 1}} #{sec, min, hour, mday, mon, year, wday, yday, isdst}
  #   send(state.port, {self(), {:command, :erlang.term_to_binary(msg)}})

  #   c_response =
  #     receive do
  #       {_, {:data, <<?r, response::binary>>}} ->
  #         :erlang.binary_to_term(response)
  #       x ->
  #         IO.inspect(x)
  #         :error
  #     after
  #       1000 ->
  #         # Not sure how this can be recovered
  #         exit(:port_timed_out)
  #     end

  #   assert c_response == {:ok}
  # end

  # test "" do

  # end
end
