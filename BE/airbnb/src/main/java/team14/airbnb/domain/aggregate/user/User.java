package team14.airbnb.domain.aggregate.user;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import team14.airbnb.domain.aggregate.accommodation.Accommodation;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {
    public static final String NOT_FOUND_MESSAGE = "사용자 정보를 찾을 수 없습니다";

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;

    private String nickname;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id", nullable = false)
    @OrderBy("createdTime desc")
    private List<Wish> wishes = new ArrayList<>();

    public User(String email, String nickname) {
        this.email = email;
        this.nickname = nickname;
    }

    public void addWish(Accommodation accommodation) {
        this.wishes.add(new Wish(accommodation));
    }

    public Set<Long> getWishIdSet() {
        return wishes.stream().map(x -> x.getId()).collect(Collectors.toSet());
    }
}