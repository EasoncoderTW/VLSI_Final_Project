def genIOPort(str, input=True, position='N', len=1):
    str = str.split(' ', 1)[1]
    InstName = str.split('_', 1)[1]
    InstName = InstName.split('(', 1)[0]
    for i in range(len):
        if input is True:
            print(f'PDIDGZ PAD_{InstName}{i} (.PAD(PI_{InstName}[{i}]), .C(WIRE_{InstName}[{i}]));')
        else:
            print(f'PDO02CDG PAD_{InstName}{i} (.I(WIRE_{InstName}[{i}]), .PAD(PO_{InstName}[{i}]));')
    print('')
    print('')
    print('')
    print('')
    for i in range(len):
        print(f'Pad: Pad_{InstName}{i} {position}')

str='PDO02CDG PAD_Data_Cahe_writeData_strb(.I(WIRE_Data_Cahe_writeData_strb), .PAD(PO_Data_Cahe_writeData_strb));'
genIOPort(str, len=16, input=False, position='W')
