# Button Mosaic

### Wheat Field with Cypresses - *Vincent van Gogh*

<div about="output_images/wheat-field-with-cypresses-button-mosaic.jpg">
	<img src="output_images/wheat-field-with-cypresses-button-mosaic.jpg" alt="Button mosaic of the painting 'Wheat Field with Cypresses' by Vincent van Gogh" title="12 655 buttons" />
	<a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
</div>

### The Great Wave off Kanagawa - *Hokusai*

<div about="output_images/great-wave-off-kanagawa-button-mosaic.jpg">
  <img src="output_images/great-wave-off-kanagawa-button-mosaic.jpg" alt="Button mosaic of the painting 'The Great Wave off Kanagawa' by Hokusai" title="15 808 buttons" />
  <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
</div>

### The Scream (1910) - *Edvard Munch*

<div about="output_images/the-scream-1910-button-mosaic.jpg">
  <img src="output_images/the-scream-1910-button-mosaic.jpg" alt="Button mosaic of the painting 'The Scream' (1910) by Edvard Munch" title="27 510 buttons" />
  <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
</div>

More results are availible in [output_images](output_images).

## Report

A report describing this work in more detail is available [here](report.pdf). 

## Usage

Set the MATLAB working directory to the *source* directory to use the program. The simplest use is then:
```
[mosaic, corrected] = buttonMosaic(image);
```
where the input *image* is the RGB-image that should be reproduced and the outputs *mosaic* and *corrected* are the resulting mosaics with and without color correction. For more advanced use, see [source/examples.m](source/examples.m).

### Number of Total Buttons
The number of total buttons used in the reproduction can be controlled by changing the minimum circle radius, *circle_packing_settings.min_radius*. The number of total buttons increases quadratically with decreasing minimum radius.

<div about="output_images/total-reduction.jpg">
  <img src="output_images/total-reduction.jpg" alt="Images reproduced with different numbers of total buttons" title="" />
  <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
</div>
<p align="center"><i>Images reproduced with different numbers of total buttons.</i></p>

<div about="output_images/circle-packing.gif">
  <img src="output_images/circle-packing.gif" alt="Circle-packing GIF with diffrent minimum circle radius" width="100%" title="" />
  <a rel="license" href="https://creativecommons.org/licenses/by/4.0/"></a>
</div>
<p align="center"><i>Circle packing with mimimum radius decrementing one pixel each frame.</i></p>

### Number of Unique Buttons
The program also has a setting to control the number of unique buttons used in the reproduction, *mosaic_settings.unique_button_limit*. The program picks the most perceptually important buttons needed to reproduce the given reference image using K-means in CIELAB space. This is similar to Lloyd-Max quantization using the LBG-algorithm.

<div about="output_images/unique-reduction.jpg">
  <img src="output_images/unique-reduction.jpg" alt="Images reproduced with different number of unique buttons" title="" />
  <a rel="license" href="https://creativecommons.org/licenses/by-nc-sa/4.0/"></a>
</div>
<p align="center"><i>Images reproduced with different numbers of unique buttons.</i></p>

## Requirements

The following products are required to run the program:

| Name                                    | Version      |
| --------------------------------------- | ------------ |
| Matlab                                  | R2019b (9.7) |
| Image Processing Toolbox                | 11.0         |
| Statistics and Machine Learning Toolbox | 11.6         |

## License and Attributions

I've created the database of buttons by splitting, cropping, masking and resizing images of buttons sourced from various places. All source images are licensed to permit sharing and adaption and I've attributed the creators of these images under *attributions* below.

<details><summary>Attributions</summary>
<br/>
<p>I've sourced the images of buttons from the following creators:</p>

<pre>
Creator: <a href="https://www.flickr.com/people/93410621@N05">https://www.flickr.com/people/93410621@N05</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/106074308@N06/">https://www.flickr.com/people/106074308@N06/</a>
License: <a href="https://creativecommons.org/licenses/by/2.0/">https://creativecommons.org/licenses/by/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/volvob12b/">https://www.flickr.com/people/volvob12b/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/twenty_questions">https://www.flickr.com/people/twenty_questions</a>
License: <a href="https://creativecommons.org/licenses/by-nc/2.0/">https://creativecommons.org/licenses/by-nc/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/markmorgantrinidad">https://www.flickr.com/people/markmorgantrinidad</a>
License: <a href="https://creativecommons.org/licenses/by/2.0/">https://creativecommons.org/licenses/by/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/presley_m/">https://www.flickr.com/people/presley_m/</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/130331218@N03/">https://www.flickr.com/people/130331218@N03/</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/mag3737/">https://www.flickr.com/people/mag3737/</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/deanhochman/">https://www.flickr.com/people/deanhochman/</a>
License: <a href="https://creativecommons.org/licenses/by/2.0/">https://creativecommons.org/licenses/by/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/littlelixie/">https://www.flickr.com/people/littlelixie/</a>
License: <a href="https://creativecommons.org/licenses/by-nc/2.0/">https://creativecommons.org/licenses/by-nc/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/obd-design">https://www.flickr.com/people/obd-design</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.pexels.com/">https://www.pexels.com/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="https://pikrepo.com/">https://pikrepo.com/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="https://pixabay.com/">https://pixabay.com/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="https://pixbay.com/">https://pixbay.com/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="https://pixnio.com/">https://pixnio.com/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="http://www.readyelements.com/">http://www.readyelements.com/</a>
License: <a href="https://creativecommons.org/publicdomain/zero/1.0/">https://creativecommons.org/publicdomain/zero/1.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/salvagenation">https://www.flickr.com/people/salvagenation</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/14903992@N08">https://www.flickr.com/people/14903992@N08</a>
License: <a href="https://creativecommons.org/licenses/by-nc/2.0/">https://creativecommons.org/licenses/by-nc/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/shellysblogger/">https://www.flickr.com/people/shellysblogger/</a>
License: <a href="https://creativecommons.org/licenses/by-nc-sa/2.0/">https://creativecommons.org/licenses/by-nc-sa/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/thevintagesailor/">https://www.flickr.com/people/thevintagesailor/</a>
License: <a href="https://creativecommons.org/licenses/by-nc/2.0/">https://creativecommons.org/licenses/by-nc/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/23882161@N03/">https://www.flickr.com/people/23882161@N03/</a>
License: <a href="https://creativecommons.org/licenses/by-nc/2.0/">https://creativecommons.org/licenses/by-nc/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/welshkaren">https://www.flickr.com/people/welshkaren</a>
License: <a href="https://creativecommons.org/licenses/by-nc/2.0/">https://creativecommons.org/licenses/by-nc/2.0/</a>
</pre>
<pre> 
Creator: <a href="https://www.flickr.com/people/30478819@N08/">https://www.flickr.com/people/30478819@N08/</a>
License: <a href="https://creativecommons.org/licenses/by/2.0/">https://creativecommons.org/licenses/by/2.0/</a>
</pre>
</details>

___

The reproduced paintings and photos are all in the public domain, but some of the source images of buttons are licensed under the share-alike license CC BY-NC-SA 2.0. The reproduced images above are therefore licensed under:

<https://creativecommons.org/licenses/by-nc-sa/4.0/>

I've bumped the license to the latest 4.0 version since these are [compatible](https://creativecommons.org/share-your-work/licensing-considerations/compatible-licenses/) and because this is suggested by CC.