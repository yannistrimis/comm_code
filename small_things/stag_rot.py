import numpy as np

def eta(ind,pos) : 

    x = pos[0]
    y = pos[1]
    z = pos[2]

    if ind == 1 :
        return 1
    elif ind == 2 :
        return int((-1)**x)
    elif ind ==3 :
        return int((-1)**(x+y))

def zeta(ind,pos) :

    x = pos[0]
    y = pos[1]
    z = pos[2]

    if ind == 1 :
        return int((-1)**(y+z))
    elif ind == 2 :
        return int((-1)**z)
    elif ind == 3 :
        return 1

def phase(ind1,ind2,pos) :

    x = pos[0]
    y = pos[1]
    z = pos[2]

    return 0.5*(1+eta(ind1,pos)*eta(ind2,pos)-zeta(ind1,pos)*zeta(ind2,pos)+eta(ind1,pos)*eta(ind2,pos)*zeta(ind1,pos)*zeta(ind2,pos))

def shift(ind,pos) :

    x = pos[0]
    y = pos[1]
    z = pos[2]

    if ind == 1 :

        if [x,y,z] == [0,0,0] :
            return [1,0,0]
        elif [x,y,z] == [1,0,0] :
            return [0,0,0]
        elif [x,y,z] == [0,1,0] :
            return [1,1,0]
        elif [x,y,z] == [0,0,1] :
            return [1,0,1]
        elif [x,y,z] == [1,1,1] :
            return [0,1,1]
        elif [x,y,z] == [0,1,1] :
            return [1,1,1]
        elif [x,y,z] == [1,0,1] :
            return [0,0,1]
        elif [x,y,z] == [1,1,0] :
            return [0,1,0]

    if ind == 2 :

        if [x,y,z] == [0,0,0] :
            return [0,1,0]
        elif [x,y,z] == [1,0,0] :
            return [1,1,0]
        elif [x,y,z] == [0,1,0] :
            return [0,0,0]
        elif [x,y,z] == [0,0,1] :
            return [0,1,1]
        elif [x,y,z] == [1,1,1] :
            return [1,0,1]
        elif [x,y,z] == [0,1,1] :
            return [0,0,1]
        elif [x,y,z] == [1,0,1] :
            return [1,1,1]
        elif [x,y,z] == [1,1,0] :
            return [1,0,0]

    if ind == 3 :

        if [x,y,z] == [0,0,0] :
            return [0,0,1]
        elif [x,y,z] == [1,0,0] :
            return [1,0,1]
        elif [x,y,z] == [0,1,0] :
            return [0,1,1]
        elif [x,y,z] == [0,0,1] :
            return [0,0,0]
        elif [x,y,z] == [1,1,1] :
            return [1,1,0]
        elif [x,y,z] == [0,1,1] :
            return [0,1,0]
        elif [x,y,z] == [1,0,1] :
            return [1,0,0]
        elif [x,y,z] == [1,1,0] :
            return [1,1,1]

def rot(ind1,ind2,pos) :

    x = pos[0]
    y = pos[1]
    z = pos[2]

    if ind1 == 1 and ind2 == 2 :

        if [x,y,z] == [0,0,0] :
            return [0,0,0]
        elif [x,y,z] == [1,0,0] :
            return [0,1,0]
        elif [x,y,z] == [0,1,0] :
            return [1,0,0]
        elif [x,y,z] == [0,0,1] :
            return [0,0,1]
        elif [x,y,z] == [1,1,1] :
            return [1,1,1]
        elif [x,y,z] == [0,1,1] :
            return [1,0,1]
        elif [x,y,z] == [1,0,1] :
            return [0,1,1]
        elif [x,y,z] == [1,1,0] :
            return [1,1,0]

    elif ind1 == 1 and ind2 == 3 :

        if [x,y,z] == [0,0,0] :
            return [0,0,0]
        elif [x,y,z] == [1,0,0] :
            return [0,0,1]
        elif [x,y,z] == [0,1,0] :
            return [0,1,0]
        elif [x,y,z] == [0,0,1] :
            return [1,0,0]
        elif [x,y,z] == [1,1,1] :
            return [1,1,1]
        elif [x,y,z] == [0,1,1] :
            return [1,1,0]
        elif [x,y,z] == [1,0,1] :
            return [1,0,1]
        elif [x,y,z] == [1,1,0] :
            return [0,1,1]

    elif ind1 == 2 and ind2 == 3 :

        if [x,y,z] == [0,0,0] :
            return [0,0,0]
        elif [x,y,z] == [1,0,0] :
            return [1,0,0]
        elif [x,y,z] == [0,1,0] :
            return [0,0,1]
        elif [x,y,z] == [0,0,1] :
            return [0,1,0]
        elif [x,y,z] == [1,1,1] :
            return [1,1,1]
        elif [x,y,z] == [0,1,1] :
            return [0,1,1]
        elif [x,y,z] == [1,0,1] :
            return [1,1,0]
        elif [x,y,z] == [1,1,0] :
            return [1,0,1]

def lab_vec(vec) :

    if vec==[0,0,0]:
        return "0"
    elif vec==[1,0,0]:
        return "1"
    elif vec==[0,1,0]:
        return "2"
    elif vec==[0,0,1]:
        return "3"
    elif vec==[1,1,1]:
        return "123"
    elif vec==[0,1,1]:
        return "23"
    elif vec==[1,0,1]:
        return "13"
    elif vec==[1,1,0]:
        return "12"

def main() :

    vec_list = [[0,0,0],[1,0,0],[0,1,0],[0,0,1],[0,1,1],[1,0,1],[1,1,0],[1,1,1]]

    print("ROTATIONS 12 13 23:\n")
    for vec in vec_list :

        lab = lab_vec(vec)

        vec12 = rot(1,2,vec)
        vec13 = rot(1,3,vec)
        vec23 = rot(2,3,vec)

        lab12 = lab_vec(vec12)
        lab13 = lab_vec(vec13)
        lab23 = lab_vec(vec23)

        phase12 = phase(1,2,vec12)
        phase13 = phase(1,3,vec13)
        phase23 = phase(2,3,vec23)
        
        print("chi(%s) -->\t%d chi(%s)\t%d chi(%s)\t%d chi(%s)"%(lab,phase12,lab12,phase13,lab13,phase23,lab23))

    print("\nSHIFTS IN 1 2 3:\n")
    for vec in vec_list :

        lab = lab_vec(vec)
        
        vec1 = shift(1,vec)
        vec2 = shift(2,vec)
        vec3 = shift(3,vec)

        lab1 = lab_vec(vec1)
        lab2 = lab_vec(vec2)
        lab3 = lab_vec(vec3)
        
        phase1 = zeta(1,vec)
        phase2 = zeta(2,vec)
        phase3 = zeta(3,vec)

        print("chi(%s) -->\t%d chi(%s)\t%d chi(%s)\t%d chi(%s)"%(lab,phase1,lab1,phase2,lab2,phase3,lab3))



if __name__ == '__main__' :
    main()
