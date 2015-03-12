require_relative 'classroom.rb'

describe 'Student' do
  let(:student) {Student.new({:phone_number=>"5", :student_id=> 123, :email_address=>"fart lane", :grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"})}
  it "should create a new student object" do
    expect(student.phone_number).to eq("5")
  end
end

describe 'Classroom' do
  let(:student) {Student.new({:phone_number=>"5", :email_address=>"fart lane", :student_id=> 123,:grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"})}
  let(:students) {[
    student,
    Student.new( {:phone_number=>"5", :email_address=>"fart lane", :student_id=> 3,:grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"}),
    Student.new( {:phone_number=>"5", :email_address=>"fart lane", :student_id=> 12,:grade_level=>3, :first_name=>"Scrappy", :last_name=>"Doo", :birthday=>"6/28/86"}),
    Student.new( {:phone_number=>"5", :email_address=>"fart lane", :student_id=> 123214,:grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"}),
    Student.new( {:phone_number=>"5", :email_address=>"fart lane", :student_id=> 1773,:grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"}),
    Student.new( {:phone_number=>"5", :email_address=>"fart lane", :student_id=> 163,:grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"}),
    Student.new( {:phone_number=>"5", :email_address=>"fart lane", :student_id=> 143,:grade_level=>3, :first_name=>"Scooby", :last_name=>"Doo", :birthday=>"6/28/86"})
    ]}
  let(:classroom) {Classroom.new(students)}

  it "should have students" do
    expect(classroom.students.first.phone_number).to eq("5")
  end

    it "should return the number of students" do
      expect(classroom.class_size?).to eq(7)
    end

    it "should return a student based on their name" do
      expect(classroom.search_by_first_name("Scooby")).to include(student)
    end

    it "should return a student based off their ID number" do
      expect(classroom.search_by_id(123)).to include(student)
    end

    it "should return a student based off their last name" do
      expect(classroom.search_by_last_name("Doo")).to include(student)
    end

    it "should return a student based off their grade level" do
      expect(classroom.search_by_grade_level(3)).to include(student)
    end

    describe "no seating chart" do
      it "should raise an exception" do
        expect{classroom.possible_seats_in_row}.to raise_error(Exception, "Must set number_of_rows")
      end
    end

    describe "making a seating chart" do
      before do
        classroom.number_of_rows=(2)
      end
      it "should allow the number of rows to be set to a number" do
        expect(classroom.number_of_rows).to eq 2
      end

      it "should calculate the number of seats in a row" do
        expect(classroom.maximum_seats_per_row).to eq 4
      end

      it "should calculate the number of seats when all rows have the same number of seats" do
        classroom.students.pop
        expect(classroom.maximum_seats_per_row).to eq 3
      end

      it "should make a seating chart" do
        seating_chart = classroom.generate_seating_chart
        expect(seating_chart[0].length).to eq 4
        expect(seating_chart[1].length).to eq 3
        expect(seating_chart[2]).to be_nil
        expect(seating_chart.flatten).to match_array(students)
      end

      it "should generate unique seating chart" do
        expect(classroom.generate_seating_chart).not_to eq(classroom.generate_seating_chart)
      end

      it "should not alter an existing seating chart" do
        expect(classroom.seating_chart).to eq(classroom.seating_chart)
      end

      it "should display rows as columns" do
        classroom.number_of_rows=(3)
        final_chart = "12:Scooby Doo, 123:Scooby Doo, 3:Scooby Doo\n163:Scooby Doo, 1773:Scooby Doo, 143:Scooby Doo\n123214:Scooby Doo"
        expect(classroom.display_seating_chart).to match /(\d+\:?).+?{7}/
      end

    end
end