describe CsvToFog::App do
  # csv-to-fog --key "Student #" --map "aws_access_key_id:Master Key" --map "aws_secret_access_key:Master Secret" spec/fixtures/aws.csv
  it 'renders valid file' do
    file_path         = spec_fixture("aws.csv")
    key               = "Student #"
    unparsed_mappings = ["aws_access_key_id:Master Key", "aws_secret_access_key:Master Secret"]
    app = CsvToFog::App.new(file_path, key, unparsed_mappings)
    app.load_file_and_validate!
    app.run
    expect(app.fog_file).to eq({
      student1: {
        aws_access_key_id: "STUDENT1KEY",
        aws_secret_access_key: "STUDENT1SECRET",
      },
      student2: {
        aws_access_key_id: "STUDENT2KEY",
        aws_secret_access_key: "STUDENT2SECRET",
      }
    })
  end
end
