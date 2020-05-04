import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class PhotoFilterViewController: UIViewController {

    let context = CIContext(options: nil)
    var originalImage: UIImage? {
        didSet {
            updateViews()
        }
    }
    
	@IBOutlet weak var brightnessSlider: UISlider!
	@IBOutlet weak var contrastSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

        let filter = CIFilter(name: "CIColorControls")! // Built-in filter from Apple
        print(filter)
        print(filter.attributes)
        
        // Demo with a starter image from storyboard
        originalImage = imageView.image
        
	}
	
    // Create a stub with default return is a good way to start
    private func filterImage(_ image: UIImage) -> UIImage? {
        
        // UIImage -> CGImage -> CIImage
        guard let cgImage = image.cgImage else { return nil }
        let ciImage = CIImage(cgImage: cgImage)
                
        // Filter image
        let filter = CIFilter(name: "CIColorControls")!
        // let filter2 = CIFilter.colorControls()
        // filter2.brightness = 3
        // filter2.brightness = brightnessSlider.value
        
        // Setting values / getting values from Core Image
        filter.setValue(ciImage, forKey: kCIInputImageKey) // same as: "inputImage")
        filter.setValue(saturationSlider.value, forKey: kCIInputSaturationKey)
        filter.setValue(brightnessSlider.value, forKey: kCIInputBrightnessKey)
        filter.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
        
        // CIImage -> CGImage -> UIImage
        
        /*
         guard let outputCIImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        */
        guard let outputCIImage = filter.outputImage else { return nil }
        
        // Render the image (do image processing here). Recipe needs to be used on image now.
        guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else {
            return nil
        }
        
        return UIImage(cgImage: outputCGImage)
    }
    
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		presentImagePickerController()
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		// TODO: Save to photo library
	}
	
    private func updateViews() {
        if let originalImage = originalImage {
            imageView.image = filterImage(originalImage)
        } else {
            imageView.image = nil
        }
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error: The photo library is not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
	// MARK: Slider events
	
    @IBAction func brightnessChanged(_ sender: UISlider) {
        updateViews()
    }

    @IBAction func contrastChanged(_ sender: Any) {
        updateViews()
    }

    @IBAction func saturationChanged(_ sender: Any) {
        updateViews()
    }
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension PhotoFilterViewController: UINavigationControllerDelegate {
    
}
