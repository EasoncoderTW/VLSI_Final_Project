def genIOPort(str, input=True, position='N', len=1):
    str = str.split(' ', 1)[1]
    InstName = str.split('_', 1)[1]
    InstName = InstName.split('(', 1)[0]
    for i in range(len):
        if input is True:
            print(f'PDIDGZ PAD_{InstName}{i} (.PAD(PI_{InstName}[{i}]), .C(WIRE_{InstName}[{i}]));')
        else:
            print(f'PDO02CDG PAD_{InstName}{i} (.I(WIRE_{InstName}[{i}]), .PAD(PI_{InstName}[{i}]));')
    print('')
    print('')
    print('')
    print('')
    for i in range(len):
        print(f'Pad: Pad_{InstName}{i} {position}')


genIOPort('PDIDGZ PAD_Inst_Cahe_readAddr_addr(.PAD(PI_Inst_Cahe_readAddr_addr), .C(WIRE_Inst_Cahe_readAddr_addr));', len=128)
