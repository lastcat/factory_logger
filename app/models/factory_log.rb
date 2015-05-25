class FactoryLog < ActiveRecord::Base
  #TODO: fix algorithm
  #TODO: fix name devide to name and traits
  #TODO: fix visualize association relation and selectable counting or not.
  def self.time_ranking
    ranking = []
    FactoryLog.all.each do |log|
      if index = ranking.index{|cd| cd[:name] == (log.name + log.traits)}
        ranking[index][:total_time] += log[:time]
        ranking[index][:count] += 1
        ranking[index][:average_time] = ranking[index][:total_time]/ranking[index][:count]
      else
       ranking.push({name: (log.name + log.traits), total_time:log.time, count: 1, average_time: log.time})
     end
    end
    ranking.sort_by!{|l| l[:total_time]}.reverse
  end

  def self.average_time(factory)
    sum_time(factory) / log_set_with_trait(factory).size
  end

  def self.sum_time(factory)
    log_set_with_trait(factory).map{|f| f.time}.inject{|fl1, fl2| fl1 + fl2 }
  end

  def self.candidates
    naming_candidates = []
    FactoryLog.all.each{|log| naming_candidates.push(log.name + log.traits) unless naming_candidates.any?{|cd| cd ==(log.name + log.traits)}}
    naming_candidates
  end

  def self.log_set_with_trait(factory_with_trait)
    factory_set = []
    FactoryLog.all.each{|log| factory_set.push(log) if log.name + log.traits == factory_with_trait}
    factory_set
  end

  def self.log_set(factory)
    factory_set = []
    FactoryLog.all.each{|log| factory_set.push(log) if log.name == factory}
    factory_set
  end
end
