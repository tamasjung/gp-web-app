#!/usr/bin/env ruby

#TODO switch between meep and meep-mpi 

system('meep ' + ARGV.join(" "))

system('h5topng *.h5')

system('tar cf outputs.tar *.png *.h5')