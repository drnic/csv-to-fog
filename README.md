CSV to .fog
===========

Converts a CSV file of credentials into a `.fog` file format.

E.g. from

```csv
Student #,Email,AWS Password,Master Key,Master Secret
student1,training+student1@starkandwayne.com,PASSWORD1,STUDENT1KEY,STUDENT1SECRET
student2,training+student2@starkandwayne.com,PASSWORD2,STUDENT2KEY,STUDENT2SECRET
```

into

```yaml
:student1:
  :aws_access_key_id: STUDENT1KEY
  :aws_secret_access_key: STUDENT1SECRET
:student2:
  :aws_access_key_id: STUDENT2KEY
  :aws_secret_access_key: STUDENT2SECRET
```

To do this:

```
csv-to-fog --key "Student #" --map "aws_access_key_id:Master Key" --map "aws_secret_access_key:Master Secret" path/to/students.csv > students_fog.yml
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
