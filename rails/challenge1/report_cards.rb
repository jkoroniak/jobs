class ReportCards
  class << self
    # Takes a has containing the students' report cards and returns an array of hashes, each one representing the best student for the subject.
    # Example input:

    {
        "bobby crimble" => { "math" => 68, "physics" => 77},
        "little susie johnson" => { "music" => 88, "math" => 91},
        "aisha sarkis" => { "math" => 96, "music" => 77, "art" => 88}
    }

    # Example output:

    # [
    #   { "math" => "aisha sarkis" },
    #   { "music" => "little susie johnson" },
    #   ...
    # ]

    #there could be better ways to do it.
    def best_students(hash)
      top = {}
      top_person = {}
      hash.each do |person, grades|
        grades.each do |subject, grade|
          if top[subject].nil?
            top[subject] = { person => grade }
            top_person[subject] = person
          elsif top[subject].values.max < grade
            top[subject] = { person => grade }
            top_person[subject] = person
          end
        end
      end
      top_person
    end
  end
end
