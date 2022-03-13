defmodule Teacher.Business do
  use Oban.Worker,
    queue: :fila_teste,
    max_attempts: 3
    # max_attempts define a quantidade máxima de retries(novas tentativas) que vão ser feitas

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => _id} = _args} = job) do
    IO.puts("Starting work...")

    Teacher.Processor.process

    job |> IO.inspect(label: "JOB: ")

    # model = Teacher.Repo.get(Teacher.Business.Man, id)

    # case args do
    #   %{"in_the" => "business"} ->
    #     IO.inspect(model, label: "in_the: ")

    #   %{"vote_for" => vote} ->
    #     IO.inspect([vote, model], label: "vote_for: ")

    #   _ ->
    #     IO.inspect(model, label: "model: ")
    # end

    IO.puts("...Finished work")

    :ok
  end
end
