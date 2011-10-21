#!/var/plone/python2.4/bin/python

# neteja.py -l [directori_desti] -k [numero_fulls_a_mantenir]
# Script que neteja un directori amb backups i guarda nomes els ultims fulls que li especifiquis
# Es basa en la utilitzacio de collective.recipe.backup
# Author: Victor Fernandez de Alba <sneridagh@gmail.com>

import sys, getopt

sys.path[0:0] = [
  '/var/plone/genwebupcZEO/produccio/eggs/collective.recipe.backup-1.7-py2.4.egg',
  '/var/plone/genwebupcZEO/produccio/eggs/zc.buildout-1.4.4-py2.4.egg',
  '/var/plone/genwebupcZEO/produccio/eggs/zc.recipe.egg-1.2.3b2-py2.4.egg',
  '/var/plone/genwebupcZEO/produccio/eggs/distribute-0.6.19-py2.4.egg',
  ]

import collective.recipe.backup.repozorunner

argv = sys.argv[1:]
try:
    opts, args = getopt.getopt(argv, "l:k:", ["location=", "keep="])
except getopt.GetoptError:
    print "neteja.py -l [directori_desti] -k [numero_fulls_a_mantenir]"
    sys.exit(2)

for opt, arg in opts:
    if opt in ("-l", "--location"):
        location = arg
    elif opt in ("-k", "--keep"):
        keep = arg

if len(opts)<2:
    print "neteja.py -l [directori_desti] -k [numero_fulls_a_mantenir]"
    sys.exit(2)

collective.recipe.backup.repozorunner.cleanup(location, keep)
