class FactoryLog < ActiveRecord::Base
  #TODO: fix algorithm
  #TODO: fix name devide to name and traits
  #TODO: fix visualize association relation and selectable counting or not.

  # Return Factory's log ranking about total time it took.
  # They are identified factory_name + trait_name.
  def self.time_ranking
    ranking = []
    FactoryLog.all.each do |log|
      if index = ranking.index{|cd| cd[:name] == (log.name + log.traits)}
        hash_data = ranking[index]
        hash_data[:total_time] += log[:time]
        hash_data[:count] += 1
        hash_data[:average_time] = hash_data[:total_time] / hash_data[:count]
      else
       ranking.push( {
                      name: (log.name + log.traits),
                      total_time:log.time,
                      count: 1,
                      average_time: log.time
                      } )
     end
    end
    ranking.sort_by!{|l| l[:total_time]}.reverse
  end

  # Return specified factory's average exectuaion time.
  def self.average_time(name_and_traits)
    logs = FactoryLog.log_set_with_trait(name_and_traits)
    logs.map{ |log| log.time }.inject{ |sum, n| sum + n } / logs.size
  end

  # Return specified factory's total exectuaion time.
  def self.sum_time(name_and_traits)
    log_set_with_trait(name_and_traits).map(&:time).inject do |log1, log2|
       log1 + log2
    end
  end

  # Return all fatcory_name + trait_name convinaitons in your factoy_logs table.
  def self.candidates
    naming_candidates = []
    FactoryLog.all.each do |log|
      factory_name = log.name
      factory_traits = log.traits
      unless naming_candidates.any? do |cd|
         cd == (factory_name + factory_traits)
       end
       naming_candidates.push(factory_name + factory_traits)
     end
     end
    naming_candidates
  end

  # Return all specified factory object
  # (identified String :"factory_name + trait_name")
  def self.log_set_with_trait(factory_name_and_trait)
    FactoryLog.all.select do |log|
      log.name + log.traits == factory_name_and_trait
    end
  end

  # Return all specified factory object(identified factory_name only)
  def self.log_set(factory)
    FactoryLog.all.select{|log| log.name == factory }
  end
end
