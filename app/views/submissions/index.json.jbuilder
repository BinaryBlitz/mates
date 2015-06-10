json.array!(@submissions) do |submission|
  json.partial! 'submission', submission: submission
end
