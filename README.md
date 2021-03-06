CSV to .fog
===========

Converts a CSV file of credentials into a `.fog` file format.

Given a CSV file (say exported from Google Spreadsheets or Excel) in `spec/fixtures/aws.csv`:

```csv
Student #,Email,AWS Password,Master Key,Master Secret
student1,training+student1@starkandwayne.com,PASSWORD1,STUDENT1KEY,STUDENT1SECRET
student2,training+student2@starkandwayne.com,PASSWORD2,STUDENT2KEY,STUDENT2SECRET
```

Run the following:

```
csv-to-fog --key "Student #" --map "aws_access_key_id:Master Key" --map "aws_secret_access_key:Master Secret" spec/fixtures/aws.csv
```

Outputs:

```yaml
:student1:
  :aws_access_key_id: STUDENT1KEY
  :aws_secret_access_key: STUDENT1SECRET
:student2:
  :aws_access_key_id: STUDENT2KEY
  :aws_secret_access_key: STUDENT2SECRET
```

By storing the output into a `yml` file, you can then load it into the `fog` CLI or a Ruby program that uses fog:

```
$ csv-to-fog --key "Student #" --map "aws_access_key_id:Master Key" --map "aws_secret_access_key:Master Secret" spec/fixtures/aws.csv > aws.yml

$ fog -C aws.yml student1
Welcome to fog interactive!
  :student1 provides AWS
```

Requires
--------

-	Ruby 1.9+
-	RubyGems

Installation
------------

Install using RubyGems:

```
$ gem install csv-to-fog
```

Contributing
------------

1.	Fork it ( https://github.com/[my-github-username]/csv-to-fog/fork )
2.	Create your feature branch (`git checkout -b my-new-feature`\)
3.	Commit your changes (`git commit -am 'Add some feature'`\)
4.	Push to the branch (`git push origin my-new-feature`\)
5.	Create a new Pull Request
