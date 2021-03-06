package team14.airbnb;

import io.jsonwebtoken.JwtException;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import team14.airbnb.domain.dto.response.ApiResult;
import team14.airbnb.exception.BadRequestException;
import team14.airbnb.exception.NotFoundException;
import team14.airbnb.exception.UnauthorizedException;


@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiResult bindException(BindException exception) {
        return ApiResult.fail(exception);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiResult validationException(MethodArgumentNotValidException exception) {
        return ApiResult.fail(exception.getAllErrors().stream().
                map(x -> x.getDefaultMessage()).
                reduce((a, b) -> a + System.lineSeparator() + b).orElse("유효성 검사 실패"));
    }

    @ExceptionHandler(BadRequestException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ApiResult badRequestException(BadRequestException badRequestException) {
        return ApiResult.fail(badRequestException);
    }

    @ExceptionHandler(NotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ApiResult notFoundException(NotFoundException notFoundException) {
        return ApiResult.fail(notFoundException);
    }

    @ExceptionHandler(UnauthorizedException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public ApiResult unauthorizedException(UnauthorizedException unauthorizedException) {
        return ApiResult.fail(unauthorizedException);
    }

    @ExceptionHandler(JwtException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED)
    public ApiResult signatureException(JwtException exception) {
        return ApiResult.fail("유효한 access token 이 아닙니다.");
    }
}
