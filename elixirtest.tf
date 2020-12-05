provider aws {
    region = var.region
    profile = "default"
}

resource "aws_instance" "instance_iex_test" {
    ami = var.ami_small
    instance_type = var.instance_small
    key_name = "test_milkersanchez"
    tags = {
        Name = "instancia_milkersanchez"
    }
    
    vpc_security_group_ids = [
       aws_security_group.iex_sg.id
    ] 
    
    user_data = <<-EOF
        #!/bin/bash
        wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
        sudo apt-get update
        sudo apt-get install -y esl-erlang
        sudo apt-get install -y inotify-tools
        sudo apt-get install elixir

        sudo apt-get install -y nodejs
        sudo apt-get install -y npm

        mix local.hex --force
        wget http://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
        mix archive.install ./phoenix_new.ez --force

        mkdir phoenix
        cd phoenix
        mix phoenix.new web --no-ecto

    EOF

}

resource "aws_db_instance" "iex_db" {
	allocated_storage = 20
	storage_type = "gp2"
	engine = "mysql"
	engine_version = "5.7"
	instance_class = "db.t2.micro"
	name = var.db_iex_name
	username = var.db_iex_username
	password = var.db_iex_pwd
	parameter_group_name = "default.mysql5.7"
	skip_final_snapshot = true
}


resource "aws_security_group" "iex_sg"{
    name = "security group iex_milker"
    ingress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_iam_user" "iex_user_test" {
    name = "iex_user"
    path = "/system/"
    tags = {
        source = "user iex test"
    }
}

resource "aws_iam_access_key" "iex_user_test" {
    user = aws_iam_user.iex_user_test.name
}


resource "aws_iam_user_policy" "iex_user_policy" {
    name = "iex_user_policy"
    user = aws_iam_user.iex_user_test.name
    policy = data.aws_iam_policy_document.iex_user_policy_document.json
}


data "aws_iam_policy_document" "iex_user_policy_document"{
	statement{
		sid = "1"

		actions = [
			"ec2:*",
			"rds:*"
		]

		resources = [
			aws_instance.instance_iex_test.arn,
			aws_db_instance.iex_db.arn
		]
	}
}