
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <math.h>
#include <iostream>

using namespace cv;
using namespace std;

void findObject(Mat *img,Mat *img_bw,int fd_threshold);
vector <double> getFourierDescriptors(vector<Point> contours);
double fdCompareCompute(vector< double > fd_target,vector< double > fd_scene);


int thresh=100;
vector <double>target_fd;


int main( int argc, char** argv)
{

	//work with target image
	Mat target,target_gray,target_bw;
	vector<vector<Point> > contours;
	vector<vector<Point> > contours0;
	vector<Vec4i> hierarchy;


	target =imread ("images/ampelmaennchen.png",1);

	//check whether the image is loaded or not
	if (target.empty())
	{
		cout << "Error : Image cannot be loaded..!!" << endl;
		return -1;
	}else {
		cout << "Success : Image  loaded..!!" << endl;


		cvtColor( target, target_gray, CV_BGR2GRAY );//Convert image to gray
		threshold( target_gray, target_bw, 51, 255,0 );// Convert the image to bw

		findContours( target_bw, contours0, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);

		contours.resize(contours0.size());
		for( size_t k = 0; k < contours0.size(); k++ )
			approxPolyDP(Mat(contours0[k]), contours[k], 3, true);

		target_fd=getFourierDescriptors(contours[0]);
		cout<<"target_fd size:"<<target_fd.size()<<endl;
		drawContours(target, contours,0, CV_RGB(255,0,0),2,LINE_AA, hierarchy );

		imshow ("Original Image",target);
		waitKey(0);  //wait infinite time for a keypress

	}

	//work with ampelwelt.jpg scene

	Mat img_welt,img_welt_gray,img_welt_bw;
	img_welt=imread("images/ampelwelt.jpg",1);
	//check whether the image is loaded or not
	if (img_welt.empty())
	{
		cout << "Error : ampelwelt Image cannot be loaded..!!" << endl;
		return -1;
	}else {

		cvtColor( img_welt, img_welt_gray, COLOR_RGB2GRAY );// Convert the image to Gray
		threshold( img_welt_gray, img_welt_bw, 51, 255,0 );// Convert the image to binary
		findObject(&img_welt,&img_welt_bw,25);

	}



	//work with cultural_notes.jpg scene

	Mat  img_cultural,img_cultural_gray,img_cultural_bw,img_cultural_blur,img_cultural_canny;

	img_cultural=imread("images/cultural_notes.jpg",1);

	if (img_welt.empty())
	{
		cout << "Error : cultural_notes Image cannot be loaded..!!" << endl;
		return -1;
	}else {

		cvtColor( img_cultural, img_cultural_gray, COLOR_RGB2GRAY );/// Convert the image to Gray
		threshold( img_cultural_gray, img_cultural_bw, 118, 255,0 );//convert the image to binary.
		findObject(&img_cultural,&img_cultural_bw,10);


	}


	return 0;
}


void findObject(Mat *img,Mat *img_bw,int fd_threshold){

	vector<vector<Point> > contours;
	vector<vector<Point> > contours0;
	vector<Vec4i> hierarchy;
	vector< complex<double> > complex_numbers;
	vector < vector<double > > fd_collector;
	vector<int > index_collecotr;
	vector<double>sum_collector;
	double min=0;
	int contour_index=0;


	findContours( *img_bw, contours0, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE);
	//findContours( *img, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE, Point(0, 0) );

	contours.resize(contours0.size());
	for( size_t k = 0; k < contours0.size(); k++ )
		approxPolyDP(Mat(contours0[k]), contours[k], 3, true);

	for (size_t idx=0;idx<contours.size();idx++)
	{
		complex_numbers.clear();
		cout<<"Object(idx):"<<idx<<endl;
		if (contours[idx].size()>fd_threshold)//best result at 25 for ampel welt
		{
			cout<<"contours[idx].size()"<<contours[idx].size()<<endl;
			index_collecotr.push_back(idx);
			fd_collector.push_back(getFourierDescriptors(contours[idx]));

		}

	}

	cout<<"scene_fd size:"<<fd_collector.size()<<endl;


	for (int i=0;i<fd_collector.size();i++)
	{

		//cout<<"scene_fd"<<i<<fd_collector[i].size()<<endl;
		sum_collector.push_back(fdCompareCompute(fd_collector[i],target_fd));
		//cout<<"sum_collector:"<<sum_collector[i]<<"@"<<index_collecotr[i]<<endl;
	}

	min=sum_collector[0];
	for(int k=0;k<sum_collector.size();k++){

		if (sum_collector[k]<min){
			min=sum_collector[k];
			contour_index=index_collecotr[k];

		}
	}

//	cout << "min:"<<min<<"index:"<<contour_index<<endl;

	drawContours(*img, contours,contour_index, CV_RGB(255,0,0),2, LINE_AA, hierarchy );
	imshow ("Result",*img);
	waitKey(0);  //wait infinite time for a keypress



}

vector <double> getFourierDescriptors(vector<Point> contours)

		{
	vector< complex<double> > complex_numbers;
	vector <double>abs_fd;

	cout<<"Received Contours size:"<<contours.size()<<endl;

	//conver contours to complex number for dft
	for(int j= 0; j < contours.size();j++)
	{
		complex<double> com_three(contours[j].y,contours[j].x) ; // value 1.5 + 3.14i
		complex_numbers.push_back(com_three);
	}

	dft(complex_numbers, complex_numbers);

	//shift and scale them for normalization.


	complex <double> s2=complex_numbers[1];
	for(int i= 1; i < complex_numbers.size(); i++)
	{
		complex <double> s1=complex_numbers[i];
		complex <double> temp;

		double a=(((s1.real())*(s2.real()))+((s1.imag())*(s2.imag())))/(pow(s2.real(),2)+pow(s2.imag(),2));
		double b=(((s2.real())*(s1.imag()))-((s1.real())*(s2.imag())))/(pow(s2.real(),2)+pow(s2.imag(),2));

		temp=(a,b);
		abs_fd.push_back(abs(temp));
	}


	return abs_fd;

		}

double fdCompareCompute(vector< double > fd_target,vector< double > fd_scene)

{
	double sum=0;
	int diff=min(fd_scene.size(),fd_target.size());

	for(int i=0;i<diff;i++)
	{
		sum+=abs(fd_scene[i]-fd_target[i]);
	}

	return sum;


}

