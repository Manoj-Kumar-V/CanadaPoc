//
//  CanadaTableViewCell.swift
//  Canada
//
//

import UIKit
import Foundation

class CanadaTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var canadaCell : Row? {
        didSet {
            guard let Item = canadaCell else {return}
            if let title = Item.title {
                canadaTitleLabel.text = title
            }else {
                canadaTitleLabel.text = NSLocalizedString("PLACEHOLDER_TITLE", comment: "PLACEHOLDER_TITLE")//PlaceHolder text if title is null
            }
            if let description = Item.description {
                canadaDescriptionLabel.text = description
            }else {
                canadaDescriptionLabel.text = NSLocalizedString("PLACEHOLDER_DESCRIPTION", comment: "PLACEHOLDER_DESCRIPTION") //PlaceHolder text if description is null
            }
            if let imageHref = Item.imageHref {
                canadaImageView.downloaded(from: imageHref)
            }else {
                canadaImageView.image = UIImage(named: "no-img-large.png") // placeholder image if imageHref is null.
            }
        }
    }
    //Title label
    private let canadaTitleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //Description Label
    private let canadaDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    //ImageView
    private let canadaImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "no-img-large.png") // placeholder image
        return imgView
    }()
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: Programatic Contsraints
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(canadaImageView)
        containerView.addSubview(canadaTitleLabel)
        containerView.addSubview(canadaDescriptionLabel)
        self.contentView.addSubview(containerView)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        canadaImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        canadaImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        canadaImageView.widthAnchor.constraint(equalToConstant:60).isActive = true
        canadaImageView.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        containerView.leadingAnchor.constraint(equalTo:self.canadaImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.bottomAnchor.constraint(equalTo:marginGuide.bottomAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo:marginGuide.topAnchor).isActive = true
        
        canadaTitleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        canadaTitleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        canadaTitleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        canadaDescriptionLabel.topAnchor.constraint(equalTo:self.canadaTitleLabel.bottomAnchor).isActive = true
        canadaDescriptionLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        canadaDescriptionLabel.bottomAnchor.constraint(equalTo:containerView.bottomAnchor).isActive = true
        canadaDescriptionLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func downloaded(from imgUrl: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        image = nil
        //Check if image is in cache and load instead of downloading every time.
        if let cachedImage = imageCache.object(forKey: NSString(string: imgUrl)) as? UIImage {
            self.image = (cachedImage )
            return
        }
        //Download image from url.
        guard let url = URL(string: imgUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {return
                    DispatchQueue.main.async() {
                        self.image = UIImage(named: "no-img-large.png") // set placeholder image if statusCode not 200.
                    }
            }
            DispatchQueue.main.async() {
                imageCache.setObject(image, forKey: NSString(string: imgUrl)) // setting downloaded image to cache for reuse.
                self.image = image
            }
        }.resume()
    }
}
