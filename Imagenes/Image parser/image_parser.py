from skimage.io import imread

theImage = imread(f'../princess-img2.png')
print(theImage.shape)
cont = 1
with open(f'IMGPRINCESS2.X68', 'w') as f:
    f.write('\n    IMGPRIN2:')
    f.write('\n        DC.L      ')
    for row in range(theImage.shape[0]):
        for column in range(theImage.shape[1]):

            red = theImage[row, column, 0]
            green = theImage[row, column, 1]
            blue = theImage[row, column, 2]

            if cont % 6 == 0:
                f.write('$00%.2X%.2X%.2X'%(blue, green, red))
            else:
                f.write('$00%.2X%.2X%.2X,'%(blue, green, red))
            if cont % 6 == 0:
                f.write('\n        DC.L      ')

            cont += 1
        