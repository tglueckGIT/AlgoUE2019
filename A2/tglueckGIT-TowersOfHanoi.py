# zur Abgabe "@mtw please review" schreiben
import sys
from argparse import ArgumentParser
parser = ArgumentParser()
parser.add_argument("-n", help = "Anzahl der Scheiben im Spiel", default = "3")
args = parser.parse_args()
step = 0

def moveDisk(fromPeg, toPeg):
    print("Move disk from " + str(fromPeg) + " to " + str(toPeg))
    global step
    step +=1

def hanoiTower(n,fromPeg, toPeg):
    if n == 1:
        moveDisk(fromPeg, toPeg)    
        return
    unusedPeg = 6 - fromPeg - toPeg
    hanoiTower(n-1, fromPeg, unusedPeg)
    moveDisk(fromPeg, toPeg)
    hanoiTower(n-1,unusedPeg,toPeg)
    return


o = open("tglueckGIT-TowersOfHanoi.out", "w")
sys.stdout = o
hanoiTower(int(args.n),1,3)
print >> sys.stderr, step
