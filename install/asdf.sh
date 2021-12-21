git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1

asdf plugin add python
asdf plugin add ruby
asdf plugin add nodejs
asdf plugin add java

asdf install python latest:3
asdf install ruby 2.7.1
asdf install java corretto-8.312.07.1
asdf install nodejs 12.18.2

asdf global nodejs 12.18.2
asdf global java corretto-8.312.07.1
