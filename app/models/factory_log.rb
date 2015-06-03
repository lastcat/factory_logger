# This is log model executed factory.
class FactoryLog < ActiveRecord::Base
  # TODO: fix visualize association relation and selectable counting or not.

  belongs_to :factory

  # Arguments is expected, hash like this,
  # name: factory_name
  # traits: trait_name(String) array
  # assos: array of hash { name:association_name, traits: trait(string) array, factory_name: factory_name }
  # I wrote factroy_inspector gem (https://github.com/lastcat/factory_inspector). Please use it.
  def self.logging(inspected_factory, execution_time)
    factory = Factory.create_unique_factory(inspected_factory)
    FactoryLog.create(factory_id: factory.id, execution_time: execution_time, factory_name: factory.to_s)
  end

  # Return Factory's log ranking about total time it took.
  def self.ranking
    results = []
    FactoryLog.all.each do |log|
      time = log.execution_time
      if index = results.index { |cd| cd[:factory] == log.factory_name }
        hash_data = results[index]
        hash_data[:total_time] += time
        hash_data[:count] += 1
        hash_data[:average_time] = hash_data[:total_time] / hash_data[:count]
      else
        results.push(
                      factory: log.factory_name,
                      total_time: time,
                      count: 1,
                      average_time: time,
                      factory_id: log.factory_id
                    )
      end
    end
    results.sort_by! { |l| l[:total_time] }.reverse
  end
end
