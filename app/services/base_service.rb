# frozen_string_literal: true

class BaseService
  def initialize(input, serializer: nil)
    @input = input
    @serializer = serializer
  end

  private

  def success(data = nil)
    data ? { success: true, data: data } : { success: true }
  end

  def failure(errors)
    { success: false, errors: errors }
  end

  def not_found(message)
    { success: false, not_found: true, errors: [message] }
  end

  def unauthorized(errors)
    { success: false, unauthorized: true, errors: errors }
  end

  def serialize(record)
    @serializer.new(record, request: @input[:request]).as_json
  end

  def serialize_collection(records)
    records.map { |r| serialize(r) }
  end

  def validate(contract_class)
    contract = contract_class.new(@input[:params])
    return failure(contract.errors) unless contract.valid?
    contract
  end

  def find_record(id = @input[:id])
    record = @input[:resource].find_by(id: id)
    record || not_found("#{@input[:resource].name} not found")
  end
end
