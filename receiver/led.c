#include <wiringPi.h>
#include <stdio.h>

void led(unsigned int bit)
{
	wiringPiSetup();

	printf("bit is %d\n", bit);
	//ensuring both LED's are off
	digitalWrite(0, HIGH);
	digitalWrite(1, HIGH);

//	printf("Enter a 1(red) or 0(green)\n");
//	scanf("%d", &bit);
	if(bit != 0)
	{
		//blink red
		pinMode(0, OUTPUT); //0 = gpio17
	        digitalWrite(0, LOW);   //led on
	        printf("red led on\n");
	        delay(100);   // wait 5 sec
        	digitalWrite(0, HIGH);  //led off
        	printf("red led off\n");
		delay(100);
	}
	else if(bit == 0)
	{
	        //blink green
                pinMode(1, OUTPUT); //1 = gpio18
                digitalWrite(1, LOW);   //led on
                printf("yellow led on\n");
                delay(100);   // wait 5 sec
                digitalWrite(1, HIGH);  //led off
                printf("yellow led off\n");
		delay(100);
	}

       //ensuring both LED's are off
        digitalWrite(0, HIGH);
        digitalWrite(1, HIGH);

}




