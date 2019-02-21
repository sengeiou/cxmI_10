//
//  NoticeCell.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/26.
//  Copyright © 2018年 韩笑. All rights reserved.
//  消息

import UIKit

protocol NoticeCellDelegate {
    func didTipNoticeDetail(messageModel: MessageCenterModel) -> Void
}

class NoticeCell: UITableViewCell {

    public var messageModel: MessageCenterModel! {
        didSet{
            guard messageModel != nil else { return }
            title.text = messageModel.title
            timelb.text = messageModel.sendTime
            detaillb.text = messageModel.contentDesc
            guard let url = URL(string: messageModel.contentUrl) else { return }
            activity.kf.setImage(with: url)
        }
    }
    
    public var delegate : NoticeCellDelegate!
    
    private var title : UILabel!
    private var timelb: UILabel!
    private var detaillb: UILabel!
    private var detailBut: UIButton!
    private var activity: UIImageView!
    private var detailIcon : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    @objc private func detailButClicked(_ sender: UIButton) {
        guard self.messageModel != nil else { return }
        guard delegate != nil else { return }
        delegate.didTipNoticeDetail(messageModel: self.messageModel)
    }
    
    private func initSubview() {
        self.selectionStyle = .none
        
        title = getLabel()
        title.font = Font15
        title.textColor = Color505050
        timelb = getLabel()
        timelb.font = Font12
        timelb.textAlignment = .right
        detaillb = getLabel()
        detaillb.font = Font13
    
        
        detailBut = UIButton(type: .custom)
        detailBut.setTitle("查看详情", for: .normal)
        detailBut.setTitleColor(Color787878, for: .normal)
        detailBut.titleLabel?.font = Font12
        detailBut.contentHorizontalAlignment = .right
        detailBut.addTarget(self, action: #selector(detailButClicked(_:)), for: .touchUpInside)
        
        detailIcon = UIImageView()
        detailIcon.image = UIImage(named: "jump")
        
        activity = UIImageView()
        
        self.contentView.addSubview(timelb)
        self.contentView.addSubview(title)
        self.contentView.addSubview(detaillb)
        self.contentView.addSubview(detailBut)
        self.contentView.addSubview(activity)
        self.contentView.addSubview(detailIcon)
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(activity)
            make.bottom.equalTo(activity.snp.top)
            make.right.equalTo(timelb.snp.left)
        }
        timelb.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(title)
            make.right.equalTo(activity)
            make.width.equalTo(title)
        }
        activity.snp.makeConstraints { (make) in
            make.top.equalTo(36 * defaultScale)
            make.bottom.equalTo(-36 * defaultScale)
            make.left.equalTo(15 * defaultScale)
            make.right.equalTo(-15 * defaultScale)
        }
        detaillb.snp.makeConstraints { (make) in
            make.left.equalTo(activity)
            make.top.equalTo(activity.snp.bottom)
            make.bottom.equalTo(0)
            make.right.equalTo(detailBut.snp.left)
        }
        detailBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(detaillb)
            make.right.equalTo(detailIcon.snp.left).offset(1)
            make.width.equalTo(90)
        }
        detailIcon.snp.makeConstraints { (make) in
            make.centerY.equalTo(detailBut.snp.centerY)
            make.right.equalTo(self.contentView).offset(-rightSpacing)
            make.height.width.equalTo(12)
        }
    }
    
    private func getLabel() -> UILabel{
        let lab = UILabel()
        lab.textColor = Color787878
        lab.textAlignment = .left
    
        return lab
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
